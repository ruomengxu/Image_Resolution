# Image Super-Resolution via Sparse Representation

The project is seeking a sparse representation for each patch
of the low-resolution input, and then use the coefficients of this
representation to generate the high-resolution output.

By jointly training two dictionaries for the low- and high-resolution image patches, it is easy to  enforce the similarity of sparse representations between the low resolution and high resolution image patch pair with respect to their
own dictionaries. Therefore, the sparse representation of a low resolution image patch can be applied with the high resolution image patch dictionary to generate a high resolution image patch.





