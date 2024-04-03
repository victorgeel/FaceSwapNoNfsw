#!/bin/bash
eval "$(conda shell.bash hook)"

# Create the Conda environment
env_exists=1
if [ ! -d ~/.conda/envs/SwapFace2Pon ]
then
  env_exists=0
  conda create -y -n SwapFace2Pon python=3.10
fi 

conda activate facefusion

# Get SwapFace2Pon from GitHub
if [ ! -d "SwapFace2Pon" ]
then
  git clone https://huggingface.co/spaces/victorisgeek/SwapFace2Pon
fi

# Update the installation if the parameter "update" was passed by running
# start.sh update
if [ $# -eq 1 ] && [ $1 = "update" ]
then
  cd SwapFace2Pon
  git pull
  cd ..
fi

# Install the required packages if the environment needs to be freshly installed or updated 
if [ $# -eq 1 ] && [ $1 = "update" ] || [ $env_exists = 0 ]
then
  cd SwapFace2Pon
  python install.py --torch cuda --onnxruntime cuda
  cd ..
  pip install pyngrok
  conda install opencv -y
  conda install ffmpeg
fi

# Start SwapFace2Pon with ngrok
if [ $# -eq 0 ]
then
  python start-ngrok.py 
elif [ $1 = "reset" ]
then
  python start-ngrok.py --reset 
fi
