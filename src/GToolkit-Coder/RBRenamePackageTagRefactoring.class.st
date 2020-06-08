Class {
	#name : #RBRenamePackageTagRefactoring,
	#superclass : #RBRefactoring,
	#instVars : [
		'packageName',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instace creation' }
RBRenamePackageTagRefactoring class >> packageName: aPackageName from: oldTagName to: newTagName [
	^ self new
		packageName: aPackageName from: oldTagName to: newTagName;
		yourself
]

{ #category : #'initialize-release' }
RBRenamePackageTagRefactoring >> packageName: aPackageName from: oldTagName to: newTagName [
	packageName := aPackageName.
	oldName := oldTagName.
	newName := newTagName
]

{ #category : #preconditions }
RBRenamePackageTagRefactoring >> preconditions [
	| package |
	package := RPackage organizer
		packageNamed: packageName asSymbol
		ifAbsent: [  ].
	^ ((RBCondition withBlock: [ package notNil ])
		errorMacro: 'Package ' , packageName , ' does not exist')
		&
			((RBCondition
				withBlock:
					[ (package classTagNamed: oldName asSymbol ifAbsent: [  ]) notNil ])
				errorMacro: 'Package tag ' , oldName , ' does not exist')
		&
			((RBCondition
				withBlock:
					[ (package classTagNamed: newName asSymbol ifAbsent: [  ]) isNil ])
				errorMacro: 'Package tag ' , newName , ' already exists')
]

{ #category : #transforming }
RBRenamePackageTagRefactoring >> transform [
	self model changes
		addChange:
			(RBRenamePackageTagChange
				packageName: packageName
				from: oldName
				to: newName)
]
