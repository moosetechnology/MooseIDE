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

	^ DragHere new
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
