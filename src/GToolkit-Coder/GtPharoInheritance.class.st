Class {
	#name : #GtPharoInheritance,
	#superclass : #GtPharoAssociation,
	#instVars : [
		'superclass',
		'subclass'
	],
	#category : 'GToolkit-Coder-Support-Pharo'
}

{ #category : #'instance creation' }
GtPharoInheritance >> from [
	^ self subclass
]

{ #category : #accessing }
GtPharoInheritance >> subclass [
	^ subclass
]

{ #category : #accessing }
GtPharoInheritance >> subclass: anObject [
	subclass := anObject
]

{ #category : #accessing }
GtPharoInheritance >> superclass [
	^ superclass
]

{ #category : #accessing }
GtPharoInheritance >> superclass: anObject [
	superclass := anObject
]

{ #category : #'instance creation' }
GtPharoInheritance >> to [
	^ self superclass
]
