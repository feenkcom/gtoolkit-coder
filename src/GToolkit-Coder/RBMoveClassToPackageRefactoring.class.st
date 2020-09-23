Class {
	#name : #RBMoveClassToPackageRefactoring,
	#superclass : #RBClassTransformation,
	#instVars : [
		'packageName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBMoveClassToPackageRefactoring class >> model: aRBModel move: aClassName to: aPackageName [
	^ self new
		model: aRBModel;
		move: aClassName to: aPackageName;
		yourself
]

{ #category : #'instance creation' }
RBMoveClassToPackageRefactoring class >> move: aClassName to: aPackageName [
	^ self new
		move: aClassName to: aPackageName;
		yourself
]

{ #category : #executing }
RBMoveClassToPackageRefactoring >> ensurePackageCreated [
	(self isPackage: packageName)
		ifTrue: [ ^ self ].
	model changes addChange: (RBAddPackageChange packageName: packageName)
]

{ #category : #testing }
RBMoveClassToPackageRefactoring >> isPackage: aSymbol [
	RPackageOrganizer default
		packageNamed: aSymbol
		ifAbsent: [ | index |
			index := aSymbol lastIndexOf: $-.
			index < 1
				ifTrue: [ ^ false ].
			^ self isPackage: (aSymbol first: index - 1) asSymbol ].
	^ true
]

{ #category : #'initialize-release' }
RBMoveClassToPackageRefactoring >> move: aClassName to: aPackageName [
	self className: aClassName.
	packageName := aPackageName
]

{ #category : #preconditions }
RBMoveClassToPackageRefactoring >> preconditions [
	^ (RBCondition
		withBlock: [ self definingClass isNotNil ]
		errorString: 'Class named ' , className , ' does not exist')
		&
			(RBCondition
				withBlock: [ packageName notNil and: [ packageName notEmpty ] ]
				errorString: 'Not a valid package name')
]

{ #category : #executing }
RBMoveClassToPackageRefactoring >> privateTransform [
	self ensurePackageCreated.
	self definingClass category: packageName.
	self model changes
		addChange: (RBClassPackageChange category: packageName for: self definingClass)
]
