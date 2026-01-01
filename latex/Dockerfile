# Use the official TeX Live image (contains a full TeX distribution)
FROM texlive/texlive:latest

# Set the working directory inside the container
# This is where we will mount your local files later
WORKDIR /workspace

# (Optional) Install additional tools if needed (e.g., make, git)
# RUN apt-get update && apt-get install -y make

# Set latexmk as the default entrypoint
# -pdf: generates pdf
# -cd: changes directory to the file location before processing
# -interaction=nonstopmode: prevents the build from hanging on errors
ENTRYPOINT ["latexmk", "-pdf", "-interaction=nonstopmode"]

# Default command argument (can be overridden at runtime)
CMD ["main.tex"]