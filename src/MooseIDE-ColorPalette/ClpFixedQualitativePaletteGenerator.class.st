"
I am a fixed qualitative palette generator. I can extract colors from predefined qualitative palettes. The extracted colors are all distinct.

**Note: You can choose until 24 colors**

Example:
```Smalltalk
ClpFixedQualitativePaletteGenerator 
	generate: 10  ""generate a palette of 10 colors from a predefined collection of colors""
```
"
Class {
	#name : #ClpFixedQualitativePaletteGenerator,
	#superclass : #ClpQualitativePaletteGenerator,
	#category : #'MooseIDE-ColorPalette-GeneratePalettes'
}

{ #category : #examples }
ClpFixedQualitativePaletteGenerator class >> example16AccentColors [

	self sample16AccentColors asCollection inspect
]

{ #category : #examples }
ClpFixedQualitativePaletteGenerator class >> example20AccentColors [

	self sample20AccentColors asCollection inspect
]

{ #category : #examples }
ClpFixedQualitativePaletteGenerator class >> example24AccentColors [

	self sample24AccentColors asCollection inspect
]

{ #category : #examples }
ClpFixedQualitativePaletteGenerator class >> example60AccentColors [
	
	self sample60AccentColors asCollection inspect
]

{ #category : #samples }
ClpFixedQualitativePaletteGenerator class >> sample16AccentColors [

	^ self new generatedPalette class withAll: { 
			  (Color fromString: '#7a7377').
			  (Color fromString: '#875692').
			  (Color fromString: '#f38400').
			  (Color fromString: '#a1caf1').
			  (Color fromString: '#be0032').
			  (Color fromString: '#008856').
			  (Color fromString: '#e68fac').
			  (Color fromString: '#0067a5').
			  (Color fromString: '#f99379').
			  (Color fromString: '#c2b280').
			  (Color fromString: '#873600').
			  (Color fromString: '#8db600').
			  (Color fromString: '#DEC663').
			  (Color fromString: '#48c9b0').
			  (Color fromString: '#ff5050').
			  (Color fromString: '#000000')}
]

{ #category : #samples }
ClpFixedQualitativePaletteGenerator class >> sample20AccentColors [

	^ self new generatedPalette class withAll: { 
			  (Color fromString: '#ff00b6').
			  (Color fromString: '#009fff').
			  (Color fromString: '#BD8A83').
			  (Color fromString: '#00ffbe').
			  (Color fromString: '#783fc1').
			  (Color fromString: '#1fb5b8').
			  (Color fromString: '#ffacfd').
			  (Color fromString: '#b1cc71').
			  (Color fromString: '#de7693').
			  (Color fromString: '#c8ff00').
			  (Color fromString: '#ff9952').
			  (Color fromString: '#93d4ff').
			  (Color fromString: '#004cff').
			  (Color fromString: '#84e19f').
			  (Color fromString: '#f7ba9e').
			  (Color fromString: '#a3cbcc').
			  (Color fromString: '#a779e0').
			  (Color fromString: '#978fa1').
			  (Color fromString: '#fae170').
			  (Color fromString: '#b09900') }
]

{ #category : #samples }
ClpFixedQualitativePaletteGenerator class >> sample24AccentColors [

	^ self new generatedPalette class withAll: { 
			  (Color fromString: '#ACA8AA').
			  (Color fromString: '#bbc9d9').
			  (Color fromString: '#ff4d57').
			  (Color fromString: '#AE7190').
			  (Color fromString: '#3283fe').
			  (Color fromString: '#feaf16').
			  (Color fromString: '#e342a1').
			  (Color fromString: '#1fecbf').
			  (Color fromString: '#2bc6e8').
			  (Color fromString: '#dea0fd').
			  (Color fromString: '#aa0dfe').
			  (Color fromString: '#f8a19f').
			  (Color fromString: '#325a9b').
			  (Color fromString: '#d97238').
			  (Color fromString: '#469a75').
			  (Color fromString: '#85660d').
			  (Color fromString: '#61d485').
			  (Color fromString: '#f7e1a0').
			  (Color fromString: '#a779e0').
			  (Color fromString: '#978fa1').
			  (Color fromString: '#3b00fb').
			  (Color fromString: '#b09900').
			  (Color fromString: '#fbe426').
			  (Color fromString: '#ed0000') }
]

{ #category : #samples }
ClpFixedQualitativePaletteGenerator class >> sample60AccentColors [
	
	| allColors |
	allColors := OrderedCollection new .
	allColors 
		addAll: self sample16AccentColors asCollection ;
	 	addAll: self sample20AccentColors asCollection ;
		addAll: self sample24AccentColors asCollection . 
	^ self new generatedPalette class withAll: allColors 
			
]

{ #category : #'instance creation' }
ClpFixedQualitativePaletteGenerator >> fromColors: aCollectionOfColors get: aNumberOfColors [

	"extract first colors aNumberOfColors from a predefined accent palette with 60 most distinguished colors"

	^ aCollectionOfColors copyFrom: 1 to: aNumberOfColors
]

{ #category : #initialization }
ClpFixedQualitativePaletteGenerator >> initialize [ 

	super initialize .
	numberOfColors := 15
]

{ #category : #accessing }
ClpFixedQualitativePaletteGenerator >> makeColors [
	
	self numberOfColors
	> self class sample60AccentColors asCollection size ifTrue: [ 
		Error signal: 'Maximum number of colors to choose is 60' ].
	^ self
		  fromColors: self class sample60AccentColors asCollection
		  get: self numberOfColors
]
