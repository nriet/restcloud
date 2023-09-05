FROM continuumio/miniconda

RUN set -eux; \
	\
	conda create -n ncl_stable -c conda-forge ncl cdo imagemagick; \
	conda clean -y -a

CMD ["conda", "run", "-n", "ncl_stable", "/bin/bash", "-c"]
