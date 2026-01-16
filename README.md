![DeLaFits](./preview.png)

DeLaFits is a pure [Delphi](https://www.embarcadero.com/products/delphi) and [Lazarus](https://www.lazarus-ide.org) library for working with data in the [FITS](https://fits.gsfc.nasa.gov) format:

- parsing a byte stream to an HDU container
- creating and deleting an HDU in a container
- reading, writing, adding, and deleting HDU header keyword records
- reading and writing HDU data array
- reading, writing, and rendering physical values (pixels) of an IMAGE extension
- reading and writing records and fields of a TABLE extension

### How to use

Add the DeLaFits directory "source" to your project's search path.

The core concept of DeLaFits is the HDU container. A typical workflow: open FITS file > create HDU container from it > select HDU > get pointer to its header and data array.

For more information, please see the [User Manual](https://felleroff.github.io/delafits/) and [Demo Projects](#demo-projects).

### Code Sample

```pascal
uses
  ..., DeLaFitsCommon, DeLaFitsCard, DeLaFitsClasses, DeLaFitsImage;

// Open the FITS file
LStream := TFileStream.Create('demo-image.fits', fmOpenRead);

// Create a FITS container
LContainer := TFitsContainer.Create(LStream);

// Get the first HDU from the container, its header and data
LItem := LContainer.Items[0];
LHead := LItem.Head;
LData := LItem.Data;

// Read the HDU header keyword records. Get the date and time
// of the observation specified by the keyword "DATE-OBS"
if LHead.LocateCard('DATE-OBS') then
begin
  LCard := TFitsDateTimeCard.Create;
  LCard.Card := LHead.Card;
  LDateTime := LCard.ValueAsDateTime;
  LCard.Free;
end;

// Read the HDU data byte array
var LBuffer: array of Byte;
SetLength(LBuffer, LData.InternalSize);
LData.ReadChunk({AInternalOffset:} 0, Length(LBuffer), {var} LBuffer[0]);

// Set the HDU class as TFitsImage and read its pixel values
if LContainer.ItemExtensionTypeIs({AIndex:} 0, TFitsImage) then
begin
  LContainer.ItemClasses[0] := TFitsImage;
  LImage := LContainer.Items[0] as TFitsImage;
  var LPixels: array of Integer;
  SetLength(LPixels, LImage.Data.ValueCount);
  LImage.Data.ReadValues({AIndex:} 0, Length(LPixels), {var} TA32c(LPixels));
end;

// Free objects
LContainer.Free;
LStream.Free;
```

### Demo Projects

The "demo" directory contains projects that demonstrate various DeLaFits features. Each project is located in a separate directory and can be compiled using Delphi ("\*.dpr") or Lazarus ("\*.lpr"):

- [container](demo/container) - parse of the Official Individual Samples of FITS files
- [newitem](demo/newitem) - create a new FITS file with the typeless HDU
- [itemhead](demo/itemhead) - read and write the HDU header
- [itemdata](demo/itemdata) - read and write the HDU data
- [imagevalues](demo/imagevalues) - read and write the IMAGE physical values
- [newframe](demo/newframe) - create a new IMAGE from the BITMAP file
- [framevalues](demo/framevalues) - read and write IMAGE frame physical values
- [renderframe](demo/renderframe) - render an IMAGE frame
- [newtable](demo/newtable) - create a new TABLE
- [tablerecords](demo/tablerecords) - read and write the TABLE records

### Data

The "data" directory contains samples FITS files.

| **[Custom Demo Samples](data)** |                                                                                                                                                     |
| :-------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| demo-item.fits        | Single Image: 1-dimensional primary array 1 x 100 with BITPIX = 8, data array contains a sequence from 0 to 99                       |
| demo-image.fits       | Single Image: 2-dimensional primary array 1400 x 1000 with BITPIX = 16                                                                              |
| demo-table.fits       | Primary HDU without data array and ASCII-TABLE extension 6 fileds x 10 records                                                                      |
| **[Official Individual Samples](https://fits.gsfc.nasa.gov/fits_samples.html)** |                                                                                                     |
| 01-HST-WFPC-II.fits   | WFPC II 800 x 800 x 4 primary array data cube containing the 4 CCD images, plus a table extension containing world coordinate parameters. This sample file has been trimmed to 200 x 200 x 4 pixels to save disk space |
| 02-HST-WFPC-II.fits   | WFPC II 1600 x 1600 primary array mosaic constructed from the 4 individual CCD chips. Image has been trimmed to 100 x 100 pixels to save disk space |
| 03-HST-FOC.fits       | FOC 1024 x 1024 primary array image, plus a table extension containing world coordinate parameters                                                            |
| 04-HST-FOS.fits       | FOS 2 x 2064 primary array spectrum containing the flux and wavelength arrays, plus a small table extension                                                   |
| 05-HST-HRS.fits       | HRS 2000 x 4 primary array spectrum, plus a small table extension                                                                                             |
| 06-HST-NICMOS.fits    | NICMOS null primary array plus 5 image extensions 270 x 263 containing the science, error, data quality, samples, and time images                             |
| 07-HST-FGS.fits       | FGS file with a 89688 x 7 2-dimensional primary array and 1 table extension. The primary array contains a time series of 7 astrometric quantities             |
| 08-ASTRO-UIT.fits     | Astro1 Ultraviolet Imaging Telescope 512 x 512 primary array image                                                                                            |
| 09-IUE-LWP.fits       | IUE spectrum contained in vector columns of a binary table                                                                                                              |
| 10-EUVE.fits          | EUVE sky image and 2D spectra, contained in multiple image extensions, with associated binary table extensions                                                          |
| 11-RANDOM-GROUPS.fits | This example file illustrates the Random Groups FITS file format which has the keywords NAXIS1 = 0 and GROUPS = T                                   |

### Repository

The only branch. The latest commit contains the current version. Tags indicate previous, outdated, but stable API versions. It is recommended to use the current version.

### Credits

DeLaFits is used in the [Lemur software](https://instalf.space) (search and detection of moving space objects in a series of astronomical frames).

DeLaFits is included in the list of [FITS I/O libraries](https://fits.gsfc.nasa.gov/fits_libraries.html) published by the FITS Support Office at NASA/GSFC.

### License

[MIT](LICENSE.md) © 2013-2026, felleroff, delafits.library@gmail.com
