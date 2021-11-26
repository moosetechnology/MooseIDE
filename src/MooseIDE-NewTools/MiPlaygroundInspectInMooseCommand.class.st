Class {
	#name : #MiPlaygroundInspectInMooseCommand,
	#superclass : #MiPlaygroundCommand,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #default }
MiPlaygroundInspectInMooseCommand class >> defaultDescription [

	^ 'Execute selection and inspect the result in a Moose inspector'
]

{ #category : #default }
MiPlaygroundInspectInMooseCommand class >> defaultName [

	^ 'Inspect in Moose'
]

{ #category : #default }
MiPlaygroundInspectInMooseCommand class >> defaultShortcutKey [

	^ ($m command shift , $i command shift) mac
	  | ($m shift control , $i shift control) win
	  | ($m shift control , $i shift control) unix
]

{ #category : #converting }
MiPlaygroundInspectInMooseCommand >> asSpecCommand [

	^ SpToolCurrentApplicationCommand decorate: (super asSpecCommand
			   iconName: #smallInspectIt;
			   shortcutKey: self class defaultShortcutKey;
			   beDisplayedOnRightSide;
			   yourself)
]

{ #category : #executing }
MiPlaygroundInspectInMooseCommand >> execute [

	| selection |
	selection := [ self context text selectedTextOrLine ]
		             on: MessageNotUnderstood
		             do: [ '' ].
	"This #on:do: is here to catch a bug in Spec adapters when there is no text to select. 
	It should be removed when this is fixed, i.e. when inspecting an empty playground does not raise an error anymore."

	selection ifEmpty: [ 
		self inform: 'Nothing to inspect in Moose'.
		^ '' ].

	MiInspectorBrowser inspect: (self context text
			 evaluate: selection
			 onCompileError: [ ^ self ]
			 onError: [ :e | e pass ])
]
