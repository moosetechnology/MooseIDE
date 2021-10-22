Class {
	#name : #MiTreeMapPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'MooseIDE-ColorPalette-Palette'
}

{ #category : #style }
MiTreeMapPalette >> beDefaultStyle [ 

	 self
	  		addName: #borderColor forColor: Color black;
			addName: #highlightBorder forColor: Color yellow darker;
			addName: #highlightEntity forColor: Color yellow darker;
			addName: #backgroundEntity forColor: (Color r: 0.68 g: 0.83 b: 0.97 alpha: 0.4). "smalltalk color blue, but lighter" 
]
