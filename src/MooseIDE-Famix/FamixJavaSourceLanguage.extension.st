Extension { #name : 'FamixJavaSourceLanguage' }

{ #category : '*MooseIDE-Famix' }
FamixJavaSourceLanguage class >> languageKeyWords [
	"according to https://docs.oracle.com/javase/specs/jls/se21/html/jls-3.html#jls-3.9
	
	For now added as an extension of MooseIDE-Famix as it was introduced for MiSourceTextBrowser
	But could be defined in Famix"

	^#(
abstract   continue   for          new         switch
assert     default    if           package     synchronized
boolean    do         goto         private     this
break      double     implements   protected   throw
byte       else       import       public      throws
case       enum       instanceof   return      transient
catch      extends    int          short       try
char       final      interface    static      void
class      finally    long         strictfp    volatile
const      float      native       super       while
	)
]
