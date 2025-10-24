"
This is a modified version of the `RSComposite` to accomodate our new DSM
"
Class {
	#name : 'MiRSDSMShape',
	#superclass : 'RSComposite',
	#category : 'MooseIDE-DSM',
	#package : 'MooseIDE-DSM'
}

{ #category : 'accessing' }
MiRSDSMShape >> color: aColor [
	self children first
		color: aColor
]

{ #category : 'initialization' }
MiRSDSMShape >> initialize [ 
	super initialize.

	self add: (RSBox new size: 15).
	self add: (RSLabel new fontSize: 5).
	self adjustToChildren

]

{ #category : 'accessing' }
MiRSDSMShape >> text: aString [

	self children second
		text: aString
]
