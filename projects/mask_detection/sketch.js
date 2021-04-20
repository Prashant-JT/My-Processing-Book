let video;
let r=false;
let NN;
let label='';
let mask=0;
let noMask=0;

function setup(){
  createCanvas(500,400);
  video=createCapture(VIDEO,vR);
  video.size(64,64);
  video.hide();
  let m={inputs: [64, 64, 4],task:'imageClassification',debug:true};
  NN=ml5.neuralNetwork(m);
}

function draw(){
  background(0);
  if(r)image(video,0,0,width,height);
  textSize(64);
  textAlign(CENTER,CENTER);
  fill(255);
  text(label,width/2,height/2);
  textSize(16);
  text("Mask dataset: "+mask,70,height-60);
  text("No mask dataset: "+noMask,82,height-30);
}

function classifyV(){NN.classify({image:video},res);}
function add(l){NN.addData({image: video},{l});}
function vR(){r=true;}

function res(e,r){
  if(!e){
    label=r[0].label;
    classifyV();
  }
}

function keyPressed(){
  if(key=='t'){
    NN.normalizeData();
    NN.train({epochs: 50},classifyV);
  }
  if(key=='m'){
    add('Nice mask!');
    mask++;
  }
  if(key=='n'){
    add('No mask!');
    noMask++;
  }
}