Class {
	#name : 'MiDeadCodeRefactoringTest',
	#superclass : 'MiAbstractDeadCodeBrowserTest',
	#category : 'MooseIDE-DeadCode-Tests',
	#package : 'MooseIDE-DeadCode-Tests'
}

{ #category : 'running' }
MiDeadCodeRefactoringTest >> populateBrowser: mooseModel [

	super populateBrowser: mooseModel.

	mooseModel rootFolder: (FileSystem memory root)
]

{ #category : 'tests' }
MiDeadCodeRefactoringTest >> testDisabledRunButtonAfterRefactor [
	"'Run' button disabled after doing the refactoring"

	| mooseModel |
	mooseModel := FamixStModel new.
	self populateBrowser: mooseModel.

	self browserRunButtonPresenter enabled: true.

	browser specModel deadEntities addAll: mooseModel allModelMethods.
	browser updateDeadEntities.

	browser specModel refactorCode.

	self deny: self browserRunButtonPresenter isEnabled
]
