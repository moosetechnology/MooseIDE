Class {
	#name : #MiTreeVisualizationPalette,
	#superclass : #MiVisualizationPalette,
	#category : #'MooseIDE-ColorPalette-Palette'
}

{ #category : #style }
MiTreeVisualizationPalette >> beDefaultStyle [

	 self 
			addName: #backgroundEntity  forColor: (Color r: 0.68 g: 0.83 b: 0.97 alpha:1.0) ; "smalltalk color blue"
			addName: #labelColor forColor: Color black ;
			addName: #highlightSelectedEntity forColor: (Color blue alpha: 0.3) "make a shadow"

]
