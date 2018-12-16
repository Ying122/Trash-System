class Trash {
  Body body;
  int lifespan = 2000;
  
  Trash(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
    //For tracking collision
    body.setUserData(this);
  }

  // Remove trash from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is it time for the trash to disappear?
  boolean done() {
    if (lifespan<0) {
      killBody();
      return true;
    }
    return false;
  }

  //Drawing the trash
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();
    lifespan -= 2;

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(255,180);
    noStroke();
    beginShape();
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // Generate the vertices and add the polygon to the Box2D world
  void makeBody(Vec2 center) {
    
    //Parameters to control the shape of polygon
    float irregularity = 40;
    int numVerts = 8;
      
    irregularity = irregularity *2*PI/numVerts;
    float[] angleSteps = new float[numVerts];
    PVector[] vertices = new PVector[numVerts];
      
    float lower = (2*PI/numVerts) - irregularity;
    float upper = (2*PI/numVerts) + irregularity;
    float sum = 0;
      
    for (int i=0;i<numVerts;i++) {
      float tmp = random(lower,upper);
      angleSteps[i] = tmp;
      sum = sum + tmp;
    }
      
    //normalize the steps so that point 0 and point n+1 are the same
    float k = sum / 2*PI;
    for (int i=0;i<numVerts;i++) {
      angleSteps[i] = angleSteps[i]/k;
    }
      
    //generate the vertices
    float angle = random(0,2*PI);
    for (int i=0;i<numVerts;i++) {
        float r_i = randomGaussian()*20;
        float x = r_i*cos(angle);
        float y = r_i*sin(angle);
        vertices[i] = new PVector(x,y);
         
        angle = angle + angleSteps[i];
      }
 
    Vec2[] vertice = new Vec2[numVerts];
    for (int i = 0; i<numVerts; i++) {
      vertice[i] = box2d.vectorPixelsToWorld(new Vec2(vertices[i].x, vertices[i].y));
    }
    
    PolygonShape ps = new PolygonShape();
    ps.set(vertice, vertice.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    //Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(ps,1.0);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}
