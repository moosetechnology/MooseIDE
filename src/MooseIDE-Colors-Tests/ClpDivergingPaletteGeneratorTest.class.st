Class {
	#name : #ClpDivergingPaletteGeneratorTest,
	#superclass : #ClpPaletteGeneratorTest,
	#instVars : [
		'diverging'
	],
	#category : #'MooseIDE-Colors-Tests-PaletteGenerators-Tests'
}

{ #category : #accessing }
ClpDivergingPaletteGeneratorTest >> classToTest [ 

	 ^ MiDivergingPaletteGenerator 
]

{ #category : #running }
ClpDivergingPaletteGeneratorTest >> setUp [
	super setUp.
	diverging := self classToTest new s: Color blue m: Color white e: Color red
]

{ #category : #tests }
ClpDivergingPaletteGeneratorTest >> testMultiHueGradient [
	
	| gradientColors |
	gradientColors := diverging multiHueGradient .
	self assert: gradientColors size equals: diverging numberOfColors .
	self assert: gradientColors first equals: Color blue.
	self assert: (gradientColors at: gradientColors size//2) equals: Color white.
	self assert: gradientColors last equals: Color red.
]
