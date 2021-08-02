"
I am a diverging palette generator, and I can make a gradient of 3 colors.

**Instance variables:**
- startingColor: a starting color wich the gradient will begin
- middleColor: a central color which the gradient changes the hue
- endingColor: an ending color wich the gradient will finish
- numberOfColors: a number of colors to make

Example:
```Smalltalk
p := ClpDivergingPaletteGenerator new.
""s: is startingColor, m: is the middleColor, e: is the endingColor""
p s: Color red m: Color white e: Color green; 
	generate: 10 ""generate 10 colors""
```


"
Class {
	#name : #ClpDivergingPaletteGenerator,
	#superclass : #ClpPaletteGenerator,
	#instVars : [
		'startingColor',
		'middleColor',
		'endingColor'
	],
	#category : #'MooseIDE-ColorPalette-GeneratePalettes'
}

{ #category : #accessing }
ClpDivergingPaletteGenerator class >> indexOfTheMiddleColor: aNumberOfColors [

	| index |
	^ index := aNumberOfColors even
		           ifTrue: [ aNumberOfColors // 2 ]
		           ifFalse: [ aNumberOfColors // 2 + 1 ]
]

{ #category : #accessing }
ClpDivergingPaletteGenerator class >> s: startColor m: middleColor e: endColor [

	^ self new s:startColor m:middleColor e:endColor
]

{ #category : #private }
ClpDivergingPaletteGenerator >> calculateStepsRGBBetween: startColor and: endColor [
	
	"calculate RGB steps between startColor and an endColor. Return a collection with the 3 RGb steps"
	
	| collection stepR stepG stepB halfNumberColors|
	
	halfNumberColors := numberOfColors // 2.
	collection := OrderedCollection new.
	stepR := endColor red - startColor red / halfNumberColors.
	stepG := endColor green - startColor green / halfNumberColors.
	stepB := endColor blue - startColor blue / halfNumberColors.
	collection 
			add: stepR value; 
			add: stepG value; 	
			add: stepB value.
	^ collection
]

{ #category : #initialization }
ClpDivergingPaletteGenerator >> initialize [ 

	super initialize .
	startingColor := Color blue .
	middleColor := Color white.
	endingColor := Color red.
]

{ #category : #accessing }
ClpDivergingPaletteGenerator >> makeColors [

	^ self multiHueGradient 
]

{ #category : #accessing }
ClpDivergingPaletteGenerator >> multiHueGradient [
	
	"create a multi hue gradient colors between startColor, middleColor and an endColor"
	
	| colors stepsRGB1 stepsRGB2 indexMiddleColor |
	stepsRGB1 := self calculateStepsRGBBetween: startingColor and: middleColor .
	stepsRGB2 := self calculateStepsRGBBetween: middleColor and: endingColor .
	indexMiddleColor := self class indexOfTheMiddleColor: numberOfColors.
	colors := OrderedCollection new.
	colors add: startingColor.
	2 to: numberOfColors - 1 do: [ :i | 
		i < indexMiddleColor ifTrue: [ 
			colors add: (Color
					 r: colors last red + stepsRGB1 first
					 g: colors last green + stepsRGB1 second
					 b: colors last blue + stepsRGB1 last) ].
		i = indexMiddleColor ifTrue: [ colors add: middleColor ].
		i > indexMiddleColor ifTrue: [ 
			colors add: (Color
					 r: colors last red + stepsRGB2 first
					 g: colors last green + stepsRGB2 second
					 b: colors last blue + stepsRGB2 last) ] ].
	colors add: endingColor.
	^ colors
]

{ #category : #accessing }
ClpDivergingPaletteGenerator >> s: aStartingColor e: anEndingcolor [
	
	startingColor := aStartingColor .
	endingColor := anEndingcolor 
]

{ #category : #accessing }
ClpDivergingPaletteGenerator >> s: aStartingColor m: aMiddleColor e: anEndingColor [

	startingColor := aStartingColor .
	middleColor := aMiddleColor.
	endingColor := anEndingColor 
]
