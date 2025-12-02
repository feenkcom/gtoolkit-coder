Class {
	#name : #GtPharoNavigationCompiledMethodsAddOnsCache,
	#superclass : #Object,
	#instVars : [
		'cache'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #private }
GtPharoNavigationCompiledMethodsAddOnsCache >> computeElementsForCompiledMethod: aCompiledMethod hostElement: aHostElement [
	<return: #Collection of: #BlElement>
	| someElements |
	someElements := GtCoderNavigationMethodTarget
			actionsForObject: aCompiledMethod
			collect: [ :eachAction | eachAction asNavigationElement: [ :e | e ] withHostElement: aHostElement ].
	cache at: aCompiledMethod put: someElements.
	^ someElements
]

{ #category : #accessing }
GtPharoNavigationCompiledMethodsAddOnsCache >> elementsForCompiledMethod: aCompiledMethod hostElement: aHostElement [
	<return: #TAsyncFuture of: #Collection of: #BlElement>
	^ cache
		at: aCompiledMethod
		ifPresent: [ :someElements | someElements asAsyncFuture ]
		ifAbsent: [ [ self computeElementsForCompiledMethod: aCompiledMethod hostElement: aHostElement ] asAsyncFuture ]
]

{ #category : #initialization }
GtPharoNavigationCompiledMethodsAddOnsCache >> initialize [
	super initialize.

	cache := AsyncSharedWeakIdentityKeyDictionary new.
]

{ #category : #'event handling' }
GtPharoNavigationCompiledMethodsAddOnsCache >> onClassAddedOrRemoved: anAnnouncement [
	cache
		keysAndValuesRemove: [ :eachCompiledMethod :someElements | 
			(eachCompiledMethod methodClass inheritsFrom: anAnnouncement classAffected)
				or: [ anAnnouncement classAffected inheritsFrom: eachCompiledMethod methodClass ] ]
]

{ #category : #'event handling' }
GtPharoNavigationCompiledMethodsAddOnsCache >> onMethodAddedOrRemoved: anAnnouncement [
	cache
		keysAndValuesRemove: [ :eachCompiledMethod :someElements | 
			(eachCompiledMethod methodClass inheritsFrom: anAnnouncement classAffected)
				or: [ anAnnouncement classAffected inheritsFrom: eachCompiledMethod methodClass ] ]
]

{ #category : #initialization }
GtPharoNavigationCompiledMethodsAddOnsCache >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when: MethodAdded , MethodRemoved
			send: #onMethodAddedOrRemoved:
			to: self;
		when: ClassAdded , ClassRemoved
			send: #onClassAddedOrRemoved:
			to: self
]

{ #category : #initialization }
GtPharoNavigationCompiledMethodsAddOnsCache >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
