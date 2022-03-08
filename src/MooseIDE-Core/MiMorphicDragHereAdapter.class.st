"
I am a morphic adapter that puts together the DragHere morph with a SpDragHere spec widget
"
Class {
	#name : #MiMorphicDragHereAdapter,
	#superclass : #SpMorphicContainerAdapter,
	#instVars : [
		'transferMorph'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #factory }
MiMorphicDragHereAdapter >> buildWidget [

	^ MiDragHereMorph new
		  changeProportionalLayout;
		  vResizing: #spaceFill;
		  hResizing: #spaceFill;
		  dragEnabled: self dragEnabled;
		  dropEnabled: self dropEnabled;
		  borderWidth: self borderWidth;
		  borderColor: self borderColor;
		  wantsDroppedMorph: [ :t | 
			  self presenter wantsDrop cull: t cull: self presenter ];
		  acceptDroppingMorph:
			  [ :t | self presenter acceptDrop cull: t cull: self presenter ]
				  yourself
]
