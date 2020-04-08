Class {
	#name : #GtBehaviorPackageRenamed,
	#superclass : #GtBehaviorChangeEvent,
	#instVars : [
		'owner',
		'package',
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Behavior - Events'
}

{ #category : #accessing }
GtBehaviorPackageRenamed >> newName [
	^ newName
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> oldName [
	^ oldName
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> oldName: anObject [
	oldName := anObject
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> owner [
	^ owner
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> owner: anObject [
	owner := anObject
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> package [
	^ package
]

{ #category : #accessing }
GtBehaviorPackageRenamed >> package: anObject [
	package := anObject
]
