#include <string>
#include <iostream>
#include "virtual_object.h"

// Headers da biblioteca GLM: criação de matrizes e vetores.
#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <matrix_operation.h>

using namespace std;


int VirtualObject::getId() { return this->id;};
const char* VirtualObject::getName() { return this->name; };

glm::mat4 VirtualObject::getModel() { return this->model; };

glm::vec3 VirtualObject::getBBoxMin() { return this->bbox_min; };
glm::vec3 VirtualObject::getBBoxMax() { return this->bbox_max; };


void VirtualObject::setModel(glm::mat4 _model) {
    this->model = _model;

    this->x = _model[3][0]; //movimentação frente/atrás
    this->y = _model[3][1]; //movimentação cima/baixo
    this->z = _model[3][2]; //movimentação esquerda/direita

    this->x_scale = _model[0][0];
    this->y_scale = _model[1][1];
    this->z_scale = _model[2][2];
};

void VirtualObject::setBBoxMin(glm::vec3 _bbox_min) { this->bbox_min = _bbox_min; };
void VirtualObject::setBBoxMax(glm::vec3 _bbox_max) { this->bbox_max = _bbox_max; };

//Translate > Rotate > Scale
void VirtualObject::move(float x, float y, float z, std::vector<VirtualObject *> virtual_objects) {
    
    bool colision = false;

    setModel(this->model * Matrix_Translate(0.0f + x, 0.0f + y, 0.0f + z));

    for(auto virtual_object : virtual_objects){
        if(this != virtual_object){
            if(this->CheckCollision(*virtual_object)){
                colision = true;
                break;
            };
        };
    }

    if(colision) {setModel(this->model * Matrix_Translate(0.0f - x, 0.0f - y, 0.0f - z));};
};

float VirtualObject::getX() { return this->x; };
float VirtualObject::getY() { return this->y; };
float VirtualObject::getZ() { return this->z; };

float VirtualObject::getPositionXMax() { return this->bbox_max.x * this->x_scale + this->x; };
float VirtualObject::getPositionXMin() { return this->bbox_min.x * this->x_scale + this->x; };
float VirtualObject::getPositionYMax() { return this->bbox_max.y * this->y_scale + this->y; };
float VirtualObject::getPositionYMin() { return this->bbox_min.y * this->y_scale + this->y; };
float VirtualObject::getPositionZMax() { return this->bbox_max.z * this->z_scale + this->z; };
float VirtualObject::getPositionZMin() { return this->bbox_min.z * this->z_scale + this->z; };

float VirtualObject::getXSize() { return this->xsize; };

float VirtualObject::getYSize() { return this->ysize; };


float VirtualObject::getLeft() { return this->left; };
float VirtualObject::getRight() { return this->right; };
float VirtualObject::getFront() { return this->front; };
float VirtualObject::getBehind() { return this->behind; };

void VirtualObject::PrintObjectMatrix(){
    PrintMatrix(this->model);
};

void VirtualObject::PrintX(){
    printf("%+0.2f\n", this->x);
};
void VirtualObject::PrintY(){
    printf("%+0.2f\n", this->y);
};

//void VirtualObject::PrintObjectVector()
//void VirtualObject::PrintObjectMatrixVectorProduct();
//void VirtualObject::PrintObjectMatrixVectorProductDivW();

//y [0,0] comprimento
//z [1,1] altura
//x [2,2] larguraS


bool VirtualObject::CheckCollision(VirtualObject &obj) // AABB - AABB collision
{
    // collision x-axis?
    bool collisionX = obj.getPositionXMax() > this->getPositionXMin() && this->getPositionXMax() > obj.getPositionXMin();
    // collision y-axis?
    bool collisionY = obj.getPositionYMax() > this->getPositionYMin() && this->getPositionYMax() > obj.getPositionYMin();
    // collision z-axis?
    bool collisionZ = obj.getPositionZMax() > this->getPositionZMin() && this->getPositionZMax() > obj.getPositionZMin();
   
    return collisionX && collisionY && collisionZ;
}  

VirtualObject::VirtualObject(int _id, const char* _name, glm::mat4 _model){
    this->id = _id;
    this->name = _name;
    this->setModel(_model);
};