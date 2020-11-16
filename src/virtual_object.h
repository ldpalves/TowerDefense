#ifndef GAMEOBJECT
#define GAMEOBJECT

// Headers da biblioteca GLM: criação de matrizes e vetores.
#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <vector>

#include <matrix_operation.h>


class VirtualObject: public MatrixOperation{
    private:
        int id;
        const char* name;
        glm::mat4 model;
        float x;
        float y;
        float z;
        float x_scale;
        float y_scale;
        float z_scale;
        float xsize;
        float ysize;
        float left;
        float right;
        float front;
        float behind;
        float up;
        float bottom;
        glm::vec3 bbox_max;
        glm::vec3 bbox_min;
    public:
        VirtualObject(int, const char*, glm::mat4);

        int getId();
        const char* getName();
        glm::mat4 getModel();
        glm::vec3 getBBoxMin();
        glm::vec3 getBBoxMax();

        void setModel(glm::mat4);
        void setBBoxMin(glm::vec3);
        void setBBoxMax(glm::vec3);

        void move(float, float, float, std::vector<VirtualObject *>);

        float getX();
        float getY();
        float getZ();

        float getPositionXMax();
        float getPositionXMin();
        float getPositionYMax();
        float getPositionYMin();
        float getPositionZMax();
        float getPositionZMin();

        float getXSize();
        float getYSize();            

        float getLeft();
        float getRight();
        float getFront();
        float getBehind();

        bool CheckCollision(VirtualObject&);

        
        void PrintObjectMatrix();

        void PrintX();
        void PrintY();
        //void PrintObjectVector();
        //void PrintObjectMatrixVectorProduct();
        //void PrintObjectMatrixVectorProductDivW();
};

#endif