#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SPHERE 0
#define BUNNY  1
#define PLANE  2
#define AMONGUS 3

uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec3 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(vec4(1.0,1.0,0.0,0.0));

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    // Vetor que define o sentido da reflex�o especular ideal.
    vec4 r = -l+2*n*dot(n,l); // vetor de reflex�o especular ideal
    // Par�metros que definem as propriedades espectrais da superf�cie
    vec3 Kd; // Reflet�ncia difusa
    vec3 Ks; // Reflet�ncia especular
    vec3 Ka; // Reflet�ncia ambiente
    float q; // Expoente especular para o modelo de ilumina��o de Phong

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    if ( object_id == SPHERE )
    {
        // Propriedades espectrais da esfera
        Kd = vec3(0.8, 0.4, 0.08);
        Ks = vec3(1.0,1.0,1.0);
        Ka = vec3(0.06,0.06,0.06);
        q = 31.0;

        //texturização
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        float raio_p = 1; // Raio de escolha arbitrária
        vec4 pos_esfera = position_model - bbox_center;

        vec4 p_linha_esfera = bbox_center + ( raio_p * pos_esfera / length(pos_esfera) );
        vec4 p_vetor_esfera = p_linha_esfera - bbox_center;

        float theta = atan(p_vetor_esfera.x, p_vetor_esfera.z);
        float phi = asin(p_vetor_esfera.y / raio_p);

        U = (theta + M_PI) /  (2 * M_PI);
        V = (phi + M_PI/2) / M_PI;
    }
    else if ( object_id == BUNNY )
    {
        // Propriedades espectrais do coelho
        Kd = vec3(0.8, 0.4, 0.8);
        Ks = vec3(0.8, 0.8, 0.8);
        Ka = vec3(0.04,0.04,0.04);
        q = 32.0;

        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        //pu = (px-ax)/(bx-ax)
        U = (position_model.x - minx) / (maxx - minx);
        V = (position_model.y - miny) / (maxy - miny);
    }
    else if ( object_id == PLANE )
    {
        // Propriedades espectrais do plano
        Kd = vec3(0.2,0.2,0.2);
        Ks = vec3(0.3,0.3,0.3);
        Ka = vec3(0.0,0.0,0.0);
        q = 20;

        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
    } else if( object_id == AMONGUS){
                Kd = vec3(0.8, 0.4, 0.08);
        Ks = vec3(1.0,1.0,1.0);
        Ka = vec3(0.06,0.06,0.06);
        q = 31.0;

        //texturização
        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        float raio_p = 1; // Raio de escolha arbitrária
        vec4 pos_esfera = position_model - bbox_center;

        vec4 p_linha_esfera = bbox_center + ( raio_p * pos_esfera / length(pos_esfera) );
        vec4 p_vetor_esfera = p_linha_esfera - bbox_center;

        float theta = atan(p_vetor_esfera.x, p_vetor_esfera.z);
        float phi = asin(p_vetor_esfera.y / raio_p);

        U = (theta + M_PI) /  (2 * M_PI);
        V = (phi + M_PI/2) / M_PI;
    }else{
        //obj desconhecido
                // Propriedades espectrais do plano
        Kd = vec3(0.0,0.0,0.0);
        Ks = vec3(0.0,0.0,0.0);
        Ka = vec3(0.0,0.0,0.0);
        q = 1.0;
        
    }
    vec3 I = vec3(1.0,1.0,1.0); //  espectro da fonte de luz

    // Espectro da luz ambiente
    vec3 Ia = vec3(0.2,0.2,0.2); //   espectro da luz ambiente

    // Termo difuso utilizando a lei dos cossenos de Lambert
    vec3 lambert_diffuse_term = Kd*I*max(0, dot(n,l)); //   termo difuso de Lambert

    // Termo ambiente
    vec3 ambient_term = Ka*Ia; // termo ambiente

    // Termo especular utilizando o modelo de ilumina��o de Phong
    vec3 phong_specular_term  = Ks*I* pow(max( 0, dot( r, v)), q ); // termo especular de Phong

    // Cor final do fragmento calculada com uma combina��o dos termos difuso,
    // especular, e ambiente. Veja slide 129 do documento Aula_17_e_18_Modelos_de_Iluminacao.pdf.
    //color = lambert_diffuse_term + ambient_term + phong_specular_term;

    // Obtemos a refletância difusa a partir da leitura da imagem TextureImage0
    vec3 Kd0 = texture(TextureImage0, vec2(U,V)).rgb; //earth
    vec3 Kd1 = texture(TextureImage1, vec2(U,V)).rgb; //earth at night
    vec3 Kd2 = texture(TextureImage2, vec2(U,V)).rgb; //grass

    // Equação de Iluminação
    float lambert = max(0,dot(n,l));

    color = Kd0 * I*max(0, dot(n,l)) + ambient_term + phong_specular_term;
    
    // Luzes acesas a noite apenas na esfera
    if ( object_id == SPHERE )
    {
        color = Kd2 * I*max(0, dot(n,l)) + ambient_term + phong_specular_term ;
    }else if( object_id == PLANE){
            color = Kd2 * (lambert + 0.01) ;

    }
    
    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color = pow(color, vec3(1.0,1.0,1.0)/2.2);
} 

