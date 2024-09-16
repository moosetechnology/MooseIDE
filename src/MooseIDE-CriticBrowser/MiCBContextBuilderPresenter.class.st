"
Class implementing the presenter used to input contexts, using Pharo code blocks.
"
Class {
	#name : #MiCBContextBuilderPresenter,
	#superclass : #MiCBRuleComponentBuilderPresenter,
	#category : #'MooseIDE-CriticBrowser-Presenters'
}

{ #category : #labels }
MiCBContextBuilderPresenter class >> defaultCodeInput [

	^ '[ :collection | collection  ]'
]

{ #category : #labels }
MiCBContextBuilderPresenter class >> ruleComponentName [

	^ 'context'
]

{ #category : #specs }
MiCBContextBuilderPresenter class >> title [

	^ 'Context builder'
]

{ #category : #action }
MiCBContextBuilderPresenter >> buildComponent: aContext [

	super buildComponent: aContext.
	aContext contextBlock: codeInputField text.

	^ aContext
]

{ #category : #layout }
MiCBContextBuilderPresenter >> codeBlockLayout [

	^ self newBoxLayoutTopToBottom
		  spacing: 5;
		  add: 'Compute context:' expand: false;
		  add: codeInputField;
		  yourself
]

{ #category : #layout }
MiCBContextBuilderPresenter >> defaultLayout [

	^ self newBoxLayoutTopToBottom
		  spacing: 10;
		  add: self titleLayout expand: false;
		  add: self codeBlockLayout;
		  add: self summaryLayout;
		  yourself
]

{ #category : #'instance creation' }
MiCBContextBuilderPresenter >> newComponent [

	^ FamixCBContext new
]

{ #category : #layout }
MiCBContextBuilderPresenter >> titleLayout [

	^ self newBoxLayoutLeftToRight
		  spacing: 10;
		  add: 'Context name:' expand: false;
		  add: titleField;
		  yourself
]
