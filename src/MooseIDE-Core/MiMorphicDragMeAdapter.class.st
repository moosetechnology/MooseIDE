Class {
	#name : #MiMorphicDragMeAdapter,
	#superclass : #SpMorphicDragMeAdapter,
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #'instance creation' }
MiMorphicDragMeAdapter >> newButton [

	^ MiDragMeMorph
		  on: self
		  getState: #state
		  action: #action
		  label: #label
		  menu: #menu:
]
