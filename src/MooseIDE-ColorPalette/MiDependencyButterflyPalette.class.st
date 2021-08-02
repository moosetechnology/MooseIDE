Class {
	#name : #MiDependencyButterflyPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'MooseIDE-ColorPalette-Palette'
}

{ #category : #style }
MiDependencyButterflyPalette >> beDefaultStyle [ 

	  self addName: #backgroundEntity forColor: Color red;
				addName: #backgroundIncoming forColor: Color green;
				addName: #backgroundOutgoing forColor: Color blue;
				addName: #labelColor forColor: Color black;
				addName: #edgeColor forColor: Color lightGray 
]

{ #category : #initialization }
MiDependencyButterflyPalette >> initialize [ 

	super initialize 
]
