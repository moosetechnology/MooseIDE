"
A MiCoSliderPresenterTest is a test class for testing the behavior of MiCoSliderPresenter
"
Class {
	#name : #MiCoSliderPresenterTest,
	#superclass : #TestCase,
	#category : #'MooseIDE-CoUsageMap-Tests-Sliders'
}

{ #category : #tests }
MiCoSliderPresenterTest >> testBasic [
	| slider value |
	slider := MiCoSliderPresenter new.
	value := ValueHolder new.
	value contents: 40.
	slider
		model: value;
		set: #contents:;
		get: #contents;
		range: (20 to: 200).
	self assert: value contents equals: 40.
	slider realValue: 20.
	self assert: value contents equals: 20.
	slider realValue: 180.
	self assert: value contents equals: 180.
	slider realValue: -40.
	self assert: value contents equals: 20.
	
	
]
