Class {
	#name : #SpColorDropdownList,
	#superclass : #SpPresenter,
	#instVars : [
		'colorList',
		'selectedColor',
		'whenColorAccepted',
		'window',
		'ok',
		'cancel',
		'setNil'
	],
	#category : #'MooseIDE-Tagging-Manager'
}

{ #category : #specs }
SpColorDropdownList class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: #colorList;
				   yourself)
		  height: 70
]
