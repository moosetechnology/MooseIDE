Class {
	#name : #MiDragMePresenter,
	#superclass : #SpButtonPresenter,
	#instVars : [
		'passenger'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #specs }
MiDragMePresenter class >> adapterName [

	^ #SpMorphicDragMeAdapter
]

{ #category : #accessing }
MiDragMePresenter >> passenger: aWidget [
	"the widget 'carried' by this drag button"
	passenger := aWidget
]

{ #category : #'as yet unclassified' }
MiDragMePresenter >> transferPassenger [
	^ SpTransferPresenter new
		  transfer: passenger;
		  from: self;
		  yourself
]
