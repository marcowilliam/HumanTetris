
class Movement {

  float x;
  float y;
  boolean draw = false;
  int type;
  boolean status = true;


  //Constructor 
  Movement(float x_, float y_, int type_) 
  { 
    x = x_;
    y = y_;
    type = type_;
  }

  private boolean checkMovement(PVector projHead, PVector projNeck, PVector projLShoulder, PVector projRShoulder, PVector projRElbow, PVector projLElbow, PVector projLHand, PVector projRHand, PVector projTorso, PVector projLHip, PVector projRHip, PVector projLKnee, PVector projRKnee, PVector projLFoot, PVector projRFoot) {

    if (type==0) {
      if (projLHand.y < projHead.y && projRHand.y > projTorso.y && projRHand.x > projRElbow.x && projLFoot.y <= projRKnee.y) {
        return true;
      }
    } else if (type==1) {
      if(projLHand.y < projLHip.y && projLHand.y > projLShoulder.y && projLHand.x < projLKnee.x && projLHand.x < projLElbow.x && projRHand.y < projRHip.y && projRHand.x > projRElbow.x && projRHand.y > projLShoulder.y && projLFoot.y <= projRKnee.y){
        return true;
      }
    } else if (type==2) {
      if(projRHand.y < projHead.y && projRElbow.y < projRShoulder.y && projLHand.y >= projTorso.y && projRFoot.x > projLHand.x && projRFoot.y <= projLKnee.y){
        return true;
      }
    } else if (type==3) {
       if(projRHand.y<projHead.y && projRHand.y > projLHand.y && projLHand.y < projHead.y && projRFoot.x < projRHand.x && projRFoot.y <= projLHip.y){
         return true;
      }
    } else if (type==4) {
      if(projRHand.y<projHead.y && projRHand.y > projLHand.y && projLHand.y < projHead.y && projRFoot.x > projLFoot.x){
        return true;
      }
    } else if (type==5) {
      if(projLHand.y < projHead.y && projLHand.x < projLElbow.x && projRHand.y > projRShoulder.y && projRFoot.y <= projLHip.y && projRFoot.x > projLFoot.x){
        return true;
      }
    } else if (type==6) {
       if(projLHand.y > projLShoulder.y && projLHand.x < projLElbow.x && projRHand.y < projHead.y && projRFoot.x > projLFoot.x && projRFoot.y > projLKnee.y){
        return true;
      }
    } else if (type==7) {
      if(projLHand.y < projRHand.y && projRHand.y < projHead.y && projRFoot.y < projRHip.y && projRFoot.y < projRKnee.y){
        return true;
      }
    } else if (type==8) {
      if(projLHand.y < projTorso.y && projLHand.y > projHead.y && projRHand.y < projTorso.y && projRHand.y > projHead.y && projLFoot.x >= projLHand.x && projLElbow.y <= projLShoulder.y && projRElbow.y <= projRShoulder.y) {
        return true;
      }                                                                                                                                  
    } else if (type==9) {
      if(projLHand.y <= projHead.y && projLElbow.y <= projLShoulder.y && projRHand.y > projRShoulder.y && projRElbow.y <= projRShoulder.y){
        return true;
      }                                                                              
    } else if (type==10) {
      if(projLHand.y <= projHead.y && projLElbow.y <= projLShoulder.y && projRElbow.y <= projRShoulder.y && projRHand.y > projHead.y && projLFoot.x > projLElbow.x && projRHand.y <= projRShoulder.y){
        return true;
      }                                                                          
    } else if (type==11) {
      if(projLHand.y < projTorso.y && projLHand.y > projHead.y && projRHand.y < projTorso.y && projRHand.y > projHead.y && projLFoot.y <= projRKnee.y && projLFoot.x < projLKnee.x){
        return true;
      }                                                                                                                               
    } else if (type==12) {
      if(projLHand.y > projTorso.y && projLHand.x < projLElbow.x && projRHand.y <= projHead.y && projRElbow.y <= projRShoulder.y && projLKnee.x > projLElbow.x){
        return true;
      }                                                                                                                               
    } else if (type==13) {
      if(projRHand.y <= projHead.y && projRElbow.y <= projRShoulder.y && projLHand.y <= projHead.y && projLElbow.y <= projLShoulder.y && projLFoot.y <= projRKnee.y && projLFoot.x < projLKnee.x){
        return true;
      }   
    } else if (type==14) {
      if(projLHand.y < projTorso.y && projLHand.y > projHead.y && projRHand.y < projTorso.y && projRHand.y > projHead.y && projLKnee.x > projLShoulder.x && projRKnee.x < projRShoulder.x){
        return true;
      }
    } else if (type==15) {
      if(projRHand.y < projRShoulder.y && projRElbow.y < projRShoulder.y && projLHand.x < projLElbow.x && projLHand.y > projTorso.y){
        return true;
      }   
    }   
    return false;
  }
}

