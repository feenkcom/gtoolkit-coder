Class {
	#name : #RBPackageClassRefactoring,
	#superclass : #RBClassRefactoring,
	#instVars : [
		'class',
		'packageName',
		'tagName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBPackageClassRefactoring class >> class: aClass packageName: packageString tagName: tagString [
	^ self new
		class: aClass packageName: packageString tagName: tagString;
		yourself
]

{ #category : #'initialize-release' }
RBPackageClassRefactoring >> class: aClass packageName: packageString tagName: tagString [
	class := self model classFor: aClass.
	className := class name.
	packageName := packageString.
	tagName := tagString
]

{ #category : #preconditions }
RBPackageClassRefactoring >> preconditions [
	^ (RBCondition isMetaclass: class) not
]

{ #category : #transforming }
RBPackageClassRefactoring >> transform [
	RPackageOrganizer default
		packageNamed: packageName asSymbol
		ifAbsent: [ self model changes
				addChange: (RBAddPackageChange packageName: packageName) ].
	class
		category:
			packageName
				,
					((tagName isNil or: [ tagName isEmpty ])
						ifTrue: [ '' ]
						ifFalse: [ '-' , tagName ]).
	self model changes defineClass: class gtDefinitionString
]
