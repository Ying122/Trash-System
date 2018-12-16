// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com


class Creature {

  // We need to keep track of a Body and a width and height
  Body body;
  float r;
  color col;
  boolean touched = false;
  
  // Constructor
  Creature(float x, float y, float r_) {
    r = r_;
    
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), r);
    body.setUserData(this);
    col = color(255);
  }
  
  Vec2 getPosition() {
    return box2d.getBodyPixelCoord(body);
  }
  
  void applyForce(Vec2 v) {
    body.applyForce(v, body.getWorldCenter());
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  
  void change() {
    col = color(255,0,0);
  }
  
  void reset() {
    col = color(255);
  }
  
  void setAngularVelocity(float a) {
    body.setAngularVelocity(a); 
  }
  void setVelocity(Vec2 v) {
     body.setLinearVelocity(v);
  }
  
  
  void setposition(float x, float y) {
    Vec2 pos = body.getWorldCenter();
    Vec2 target = box2d.coordPixelsToWorld(x,y);
    Vec2 diff = new Vec2(target.x-pos.x,target.y-pos.y);
    diff.mulLocal(10);
    setVelocity(diff);
    setAngularVelocity(0);
    body.setTransform(box2d.coordPixelsToWorld(x, y), 0);
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    stroke(col);
    strokeWeight(2);
    ellipse(0, 0, r*2, r*2);
    ellipse(0, 0, r*2-3, r*2-3);
    ellipse(0, 0, r*2+3, r*2+3);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float r) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
   body.setAngularVelocity(random(-10, 10));
  }
}
