"
I am the Midas visualization palette
"
Class {
	#name : #MiVisualizationPalette,
	#superclass : #MiPalette,
	#category : #'MooseIDE-Colors-Palettes'
}

{ #category : #style }
MiVisualizationPalette >> beDefaultStyle [ 

	self addName: #highlightColor forColor: Color yellow darker  
		"no highlightColor -> theme selectionColor"
]

{ #category : #initialization }
MiVisualizationPalette >> initialize [

	super initialize .
	self  beDefaultStyle
]
