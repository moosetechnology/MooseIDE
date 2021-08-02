Class {
	#name : #ClpSequentialPaletteGeneratorTest,
	#superclass : #ClpPaletteGeneratorTest,
	#instVars : [
		'sequentialPalette'
	],
	#category : #'MooseIDE-ColorPalette-Tests-GeneratePalettes-Test'
}

{ #category : #accessing }
ClpSequentialPaletteGeneratorTest >> classToTest [ 

	 ^ ClpSequentialPaletteGenerator  
]

{ #category : #running }
ClpSequentialPaletteGeneratorTest >> setUp [
	super setUp.
	
	sequentialPalette := ClpSequentialPaletteGenerator new 
]

{ #category : #tests }
ClpSequentialPaletteGeneratorTest >> testGradient [

	self assert: sequentialPalette gradient size equals: 20
	
]
