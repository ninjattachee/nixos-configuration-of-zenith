{ pkgs, ... }:

let
  myTensorRT = pkgs.stdenv.mkDerivation rec  {
    name = "tensorrt-10.9.0.34";
    src = /home/atank/Downloads/TensorRT-10.9.0.34.Linux.x86_64-gnu.cuda-12.8.tar.gz;
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ 
      pkgs.cudaPackages.cuda_cudart 
      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
    ];
    installPhase = ''
    mkdir -p $out
    tar -xzf $src -C $out --strip-components=1
    '';
  };

in {
  environment.systemPackages = [ myTensorRT ];
}
