Class {
	#name : #ClpPaletteGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'generator'
	],
	#category : #'MooseIDE-ColorPalette-Tests-GeneratePalettes-Test'
}

{ #category : #testing }
ClpPaletteGeneratorTest class >> isAbstract [ 
	
	^ self == ClpPaletteGeneratorTest
]

{ #category : #accessing }
ClpPaletteGeneratorTest >> classToTest [ 

	 ^ self subclassResponsibility 
]

{ #category : #initialization }
ClpPaletteGeneratorTest >> setUp [ 

	generator := self classToTest new
]

{ #category : #tests }
ClpPaletteGeneratorTest >> testGenerate [

	self assert: generator generate asCollection size equals: generator numberOfColors  
]
