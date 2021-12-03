Class {
	#name : #SpRGBChooserTest,
	#superclass : #TestCase,
	#instVars : [
		'colorChooser'
	],
	#category : #'MooseIDE-Tests'
}

{ #category : #initialization }
SpRGBChooserTest >> setUp [
	super setUp.
	colorChooser := SpRGBChooser new.
]

{ #category : #tests }
SpRGBChooserTest >> testBlueSlider [
	colorChooser blueSlider value: 255.
	self assert: colorChooser color equals: Color blue
]

{ #category : #tests }
SpRGBChooserTest >> testColorPreview [
	| expectedColor actualColor |
	expectedColor := Color random.

	self assert: colorChooser colorPreviewed equals: Color black.

	colorChooser setColor: expectedColor.
	
	actualColor := colorChooser colorPreviewed.

	self assert: (actualColor red roundTo: 3) equals: (expectedColor red roundTo: 3).
	self assert: (actualColor blue roundTo: 3) equals: (expectedColor blue roundTo: 3).
	self assert: (actualColor green roundTo: 3) equals: (expectedColor green roundTo: 3).
]

{ #category : #tests }
SpRGBChooserTest >> testGreenSlider [
	colorChooser greenSlider value: 255.
	self assert: colorChooser color equals: Color green
]

{ #category : #tests }
SpRGBChooserTest >> testRedSlider [
	colorChooser redSlider value: 255.
	self assert: colorChooser color equals: Color red
]

{ #category : #tests }
SpRGBChooserTest >> testSelectASample [
	| aSample actualColor |
	aSample := colorChooser colorSamples items atRandom.

	self assert: colorChooser colorPreviewed equals: Color black.

	aSample click.
	
	actualColor := colorChooser colorPreviewed.

	self assert: (actualColor red roundTo: 3) equals: (aSample color red roundTo: 3).
	self assert: (actualColor blue roundTo: 3) equals: (aSample color blue roundTo: 3).
	self assert: (actualColor green roundTo: 3) equals: (aSample color green roundTo: 3).
]
