"
I am a generator of sequential palette. I take 2 different colors and i can make a gradient between them. The number of colors also must be given.

**Instance variables:**
- startingColor: a starting color wich the gradient will begin
- endingColor: an ending color wich the gradient will finish
- numberOfColors: a number of colors to make

Example:
```Smalltalk
| p |
p := MiSequentialPaletteGenerator new.
p	startColor: Color red endColor: Color white;
	generate: 10
```
"
Class {
	#name : #MiSequentialPaletteGenerator,
	#superclass : #MiPaletteGenerator,
	#instVars : [
		'startingColor',
		'endingColor'
	],
	#category : #'MooseIDE-Colors-PaletteGenerators'
}

{ #category : #examples }
MiSequentialPaletteGenerator class >> example [

	(self new
		 startColor: Color red endColor: Color white;
		 generate: 10) inspect
]

{ #category : #accessing }
MiSequentialPaletteGenerator >> calculateStepsRGBBetween: startColor and: endColor [

	| collection stepR stepG stepB |

	collection := OrderedCollection new.
	stepR := endColor red - startColor red / numberOfColors.
	stepG := endColor green - startColor green / numberOfColors.
	stepB := endColor blue - startColor blue / numberOfColors.
	collection 
			add: stepR value; 
			add: stepG value; 	
			add: stepB value.
	^ collection
	
]

{ #category : #private }
MiSequentialPaletteGenerator >> generateColorsStartWith: aStartingColor respecting: stepsRGB [
	
	| colors |
	colors := OrderedCollection new.
	colors add: aStartingColor.
	(2 to: numberOfColors - 1) do: [ :i | 
		colors add: (Color
				 r: colors last red + stepsRGB first
				 g: colors last green + stepsRGB second
				 b: colors last blue + stepsRGB last) ].
	colors add: endingColor.		
	^ colors

]

{ #category : #accessing }
MiSequentialPaletteGenerator >> gradient [

	| stepsRGB |
	stepsRGB := self
		            calculateStepsRGBBetween: startingColor
		            and: endingColor.
	^ self generateColorsStartWith: startingColor respecting: stepsRGB
]

{ #category : #initialization }
MiSequentialPaletteGenerator >> initialize [ 

	super initialize.
	startingColor := Color red darker .
	endingColor := Color white
]

{ #category : #accessing }
MiSequentialPaletteGenerator >> makeColors [
	 
	^ self gradient

	

	
]

{ #category : #accessing }
MiSequentialPaletteGenerator >> startColor: aStartingColor endColor: anEndingColor [ 

	startingColor := aStartingColor .
	endingColor := anEndingColor .

	
 
]
