# ftest2
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FTafThorne%2Fftest2.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FTafThorne%2Fftest2?ref=badge_shield)

Dockerfile that sets up a basic CentOS production environment with a number of libraries configured, fdev2 adds development tools to it

The Docker Image is listed on Docker Hub:
https://hub.docker.com/r/tafthorne/ftest2/

To pull the image:

 docker pull tafthorne/fdtest2

An overview of the included libraries is given below.

## Using This Image
The expected way to use this image is to navigate to the working directory
where your executable resides and start an interactive session.

  docker run -ti --volume="${PWD}:/shared" -w "/shared" tafthorne/ftest2

Then within the running container you can call make or gcc as if it were a
native tool.  The libraries added to this image will be in the global include
path.

## spdlog

spdlog is a fast, header only C++ logging library.  For further details please
see their project page.
* https://github.com/gabime/spdlog

## Contributing

Please see the notes in CONTRIBUTING.md.



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FTafThorne%2Fftest2.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FTafThorne%2Fftest2?ref=badge_large)