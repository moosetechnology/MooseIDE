Class {
	#name : 'MiTagCreationForm',
	#superclass : 'MiTagAbstractForm',
	#category : 'MooseIDE-Tagging-Browser',
	#package : 'MooseIDE-Tagging',
	#tag : 'Browser'
}

{ #category : 'initialization' }
MiTagCreationForm >> initializeFormLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   add: extentButton;
				   add: intentButton;
				   yourself)
		  expand: false;
		  add: self formLayout expand: true;
		  add: queryListLabeled expand: false;
		  yourself
]
