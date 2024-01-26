Class {
	#name : #MiClipboardCopyCommandTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'presenter',
		'browser',
		'helper'
	],
	#category : #'MooseIDE-QueriesBrowser-Tests-Queries Browser'
}

{ #category : #running }
MiClipboardCopyCommandTest >> setUp [

	| parentPresenter |
	super setUp.

	helper := FQTestsHelper new.
	browser := MiQueriesBrowser openForTests: self application.
	browser receiveEntity: helper classesAndMethods.
	parentPresenter := browser
		                   instantiate: MiQueriesListPresenter
		                   on: browser.

	presenter := MiQueryListItemPresenter
		             on: browser rootQuery
		             owner: parentPresenter
		             queriesListPresenter: parentPresenter.
	presenter setQueryNumber: 1.
	presenter updateQueryConfiguratorPresenterFor: FQStringQuery
]

{ #category : #running }
MiClipboardCopyCommandTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	super tearDown
]

{ #category : #tests }
MiClipboardCopyCommandTest >> testExecuteCommand [

	| newQuery rootQuery |
	rootQuery := FQRootQuery new
		result: helper classesAndMethods;
		yourself.
	newQuery := FQStringQuery defaultForParent: rootQuery.
	newQuery
		comparator: #includesSubstring:;
		property: #name;
		valueToCompare: 'a'.
	presenter configureFor: newQuery.
	presenter rootCommandsGroup entries second decoratedCommand execute.

	self
		assert: Clipboard clipboardText equals: '(FQStringQuery property: #name comparator: #includesSubstring: valueToCompare: ''a'')'
]
