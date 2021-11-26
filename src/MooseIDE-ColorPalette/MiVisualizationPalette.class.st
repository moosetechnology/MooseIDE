"
I am the Midas visualization palette
"
Class {
	#name : #MiVisualizationPalette,
	#superclass : #Palette,
	#category : #'MooseIDE-ColorPalette-Palette'
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
