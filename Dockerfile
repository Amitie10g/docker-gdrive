FROM ocaml/opam2:alpine AS builder
MAINTAINER Davod (Amitie10g) <davidkingnt@gmail.com>

RUN OPAMYES=true opam init && \
  OPAMYES=true opam depext google-drive-ocamlfuse && \
  OPAMYES=true opam install google-drive-ocamlfuse

FROM alpine:latest
RUN apk add --no-cache libressl2.7-libtls fuse libgmpxx sqlite-libs libcurl ncurses-libs

ENV DRIVE_PATH="/drive"
ENV LABEL="gdrive"

COPY init.sh /
COPY --from=builder /root/.opam/system/bin/google-drive-ocamlfuse /bin/google-drive-ocamlfuse
RUN chmod +x /init.sh
RUN mkdir -p $DRIVE_PATH

CMD ["/init.sh"]
