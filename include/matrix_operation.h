#ifndef _MATRICES_OPERATION_H
#define _MATRICES_OPERATION_H

#include <cstdio>
#include <cstdlib>

#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/matrix_transform.hpp>

class MatrixOperation{
    private:
        glm::mat4 matrix;
    public:
        glm::mat4 Matrix(
            float, float, float, float,
            float, float, float, float,
            float, float, float, float,
            float, float, float, float 
        );
        glm::mat4 Matrix_Identity();        
        glm::mat4 Matrix_Translate(float, float, float);
        glm::mat4 Matrix_Scale(float, float, float);
        glm::mat4 Matrix_Rotate_X(float);
        glm::mat4 Matrix_Rotate_Y(float);
        glm::mat4 Matrix_Rotate_Z(float);
        float norm(glm::vec4);
        glm::mat4 Matrix_Rotate(float, glm::vec4);
        glm::vec4 crossproduct(glm::vec4, glm::vec4);
        float dotproduct(glm::vec4, glm::vec4);
        glm::mat4 Matrix_Camera_View(glm::vec4, glm::vec4, glm::vec4);
        glm::mat4 Matrix_Orthographic(float, float, float, float, float, float);
        glm::mat4 Matrix_Perspective(float, float, float, float);
        void PrintMatrix(glm::mat4);
        void PrintVector(glm::vec4);
        void PrintMatrixVectorProduct(glm::mat4, glm::vec4);
        void PrintMatrixVectorProductDivW(glm::mat4, glm::vec4);
};

#endif
