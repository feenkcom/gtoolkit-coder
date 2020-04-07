Class {
	#name : #RBChangeSuperclassTransformation,
	#superclass : #RBClassRefactoring,
	#instVars : [
		'class',
		'newSuperclass'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBChangeSuperclassTransformation class >> changeSuperclassOf: aClass to: superClass [
	^ self new
		changeSuperclassOf: aClass to: superClass;
		yourself
]

{ #category : #'initialize-release' }
RBChangeSuperclassTransformation >> changeSuperclassOf: aClass to: superClass [
	className := aClass name.
	class := self model classFor: aClass.
	newSuperclass := self model classFor: superClass
]

{ #category : #preconditions }
RBChangeSuperclassTransformation >> preconditions [
	^ (RBCondition isMetaclass: class) not
		& (RBCondition isMetaclass: newSuperclass) not
		&
			(RBCondition
				withBlock: [ (newSuperclass withAllSuperclasses includes: class)
						ifTrue: [ ^ self
								refactoringError:
									'Assigning superclass ' , newSuperclass name , ' to ' , class name
										, ' would create a cycle in the hierarchy' ].
					true ])
]

{ #category : #transforming }
RBChangeSuperclassTransformation >> transform [
	class superclass: newSuperclass.
	class classSide superclass: newSuperclass classSide.
	self model changes defineClass: class gtDefinitionString
]
