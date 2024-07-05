Class {
	#name : #ClpSequentialPaletteGeneratorTest,
	#superclass : #ClpPaletteGeneratorTest,
	#instVars : [
		'sequentialPalette'
	],
	#category : #'MooseIDE-Colors-Tests-PaletteGenerators-Tests'
}

{ #category : #accessing }
ClpSequentialPaletteGeneratorTest >> classToTest [ 

	 ^ MiSequentialPaletteGenerator  
]

{ #category : #running }
ClpSequentialPaletteGeneratorTest >> setUp [
	super setUp.
	
	sequentialPalette := MiSequentialPaletteGenerator new 
]

{ #category : #tests }
ClpSequentialPaletteGeneratorTest >> testGradient [

	self assert: sequentialPalette gradient size equals: 20
	
]
