"
A MiCoDualSliderPresenterTest is a test class for testing the behavior of MiCoDualSliderPresenter
"
Class {
	#name : #MiCoDualSliderPresenterTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests-Sliders'
}

{ #category : #tests }
MiCoDualSliderPresenterTest >> testBasic [
	| slider value |
	slider := MiCoDualSliderPresenter new.
	slider model: OrderedCollection new.
	value := ValueHolder new.
	value contents: (30 to: 40).
	slider
		model: value;
		set: #contents:;
		get: #contents;
		range: (0 to: 500).
	self assert: value contents equals: (30 to: 40).
	slider maxValue: 100.
	self assert: value contents equals: (30 to: 100).
	slider minValue: 80.
	self assert: value contents equals: (80 to: 100).
	slider maxValue: 600.
	self assert: value contents equals: (80 to: 500).
]
