![DeLaFits](./preview.png)

DeLaFits is a native [Delphi](https://www.embarcadero.com/products/delphi) and [Lazarus](https://www.lazarus-ide.org) class library for operation with files in the [FITS](https://fits.gsfc.nasa.gov) format:

- reading, editing and building the HDU (header and data units)
- high-level access to Standard Extensions
- data rendering of the IMAGE extension

### How to use

Just add the library `source` directory to your project’s [search path](https://wiki.freepascal.org/IDE_Window:_Compiler_Options#Other_Unit_Files)

Basic API is in DeLaFitsCommon and DeLaFitsClasses units

For details, see [User's Manual](https://felleroff.github.io/delafits/)

### Code Sample

```pascal
uses
  SysUtils, Classes, Graphics, DeLaFitsCommon, DeLaFitsClasses, DeLaFitsPicture;

var

  Stream: TFileStream;

  Container: TFitsContainer;
  Picture: TFitsPicture;
  Head: TFitsPictureHead;
  Data: TFitsPictureData;
  Frame: TFitsPictureFrame;

  IndexLine: Integer;
  IndexElems: Int64;
  X, CountElems: Integer;
  Elems: array of Double;
  Region: TRegion;
  Bitmap: TBitmap;

begin

  Stream    := nil;
  Container := nil;
  Bitmap    := nil;

  try

    // Open FITS file

    Stream := TFileStream.Create('demo-image.fits', fmOpenReadWrite);

    // Create FITS container

    Container := TFitsContainer.Create(Stream);

    // Cast HDU[0] as IMAGE extension

    Picture := Container.Reclass(0, TFitsPicture) as TFitsPicture;

    // Get Objects of IMAGE extension

    Head  := Picture.Head;
    Data  := Picture.Data;
    Frame := Picture.Frames[0];

    // Edit Header

    IndexLine := Head.IndexOf('DATE-OBS');
    if IndexLine < 0 then
    begin
      Head.AddDateTime('DATE-OBS', Now, 'Add datetime');
    end
    else
    begin
      Head.ValuesDateTime[IndexLine] := Now;
      Head.Notes[IndexLine] := 'Set datetime';
    end;

    // Edit Data

    IndexElems := Frame.IndexElems;
    CountElems := Frame.LocalWidth;
    SetLength(Elems, CountElems);
    Data.ReadElems(IndexElems, CountElems, TA64f(Elems));
    for X := 0 to CountElems - 1 do
      Elems[X] := Elems[X] + 1.0;
    Data.WriteElems(IndexElems, CountElems, TA64f(Elems));

    // Render

    Bitmap := TBitmap.Create;
    Region := ToRegion(0, 0, 300, 300);
    Frame.Tone.Contrast := 1.2;
    Frame.Geometry.Scale(2.0, 2.0, xy00).Rotate(45.0, xy00);
    Frame.RenderScene(Bitmap, Region);
    Bitmap.SaveToFile('demo-image.bmp');

  finally
    Stream.Free;
    Container.Free;
    Elems := nil;
    Bitmap.Free;
  end;

end.
```

### Data

The `data` directory contains samples FITS files

| **[Custom Demo Samples](data)** |                                                                                                                                                     |
|:--------------------- |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| demo-image.fits       | Single Image: 2-dimensional primary array 1400 x 1000 with BITPIX = 16                                                                              |
| demo-simple.fits      | Single Image: 1-dimensional primary array 1 x 100 with BITPIX = 8, data block contains a sequence from 0 to 99                                      |
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

### Demo

The `demo` directory contains examples of using the library. Each example is located in a separate directory and has two entry points: Delphi and Lazarus project. 

- [editdata](demo/editdata) - reading and editing the Data of the FITS file
- [edithead](demo/edithead) - reading and editing the Header of the FITS file
- [makeimage](demo/makeimage) - make a new IMAGE extension from a BITMAP file
- [makeitem](demo/makeitem) - make a new FITS file
- [markup](demo/markup) - markup of the Official Individual Samples of FITS files
- [renderimage](demo/renderimage) - render the IMAGE extension of the FITS file

### Credits

DeLaFits is used in the [CoLiTec](http://www.neoastrosoft.com) project - software package for automatic processing of CCD observations for accurate astrometry and photometry.

The list of known FITS I/O libraries (including DeLaFits) is published in the official resource of the [FITS Support Office](https://fits.gsfc.nasa.gov/fits_libraries.html) at NASA/GSFC at NASA/GSFC.

### License

[MIT](LICENSE.md) © 2013-2021, felleroff, delafits.library@gmail.com
