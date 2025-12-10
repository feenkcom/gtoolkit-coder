Class {
	#name : #GtCoderNavigationCompiledMethodsAddOnsCache,
	#superclass : #Object,
	#instVars : [
		'elementCache',
		'coderViewModelCache'
	],
	#classVars : [
		'IsEnabled'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #settings }
GtCoderNavigationCompiledMethodsAddOnsCache class >> disable [
	IsEnabled := false
]

{ #category : #settings }
GtCoderNavigationCompiledMethodsAddOnsCache class >> enable [
	IsEnabled := true
]

{ #category : #settings }
GtCoderNavigationCompiledMethodsAddOnsCache class >> isEnabled [
	^ IsEnabled ifNil: [ IsEnabled := true ]
]

{ #category : #private }
GtCoderNavigationCompiledMethodsAddOnsCache >> addOnsFutureForCompiledMethod: aCompiledMethod [
	<return: #GtTextualCoderViewModel>
	| coderViewModel |
	coderViewModel := coderViewModelCache
			at: aCompiledMethod
			ifPresent: [ :aCoderViewModel | aCoderViewModel ]
			ifAbsentPut: [ (GtPharoMethodCoder forMethod: aCompiledMethod)
					asCoderViewModel ].

	^ coderViewModel
]

{ #category : #accessing }
GtCoderNavigationCompiledMethodsAddOnsCache >> elementsForCompiledMethod: aCompiledMethod [
	<return: #TAsyncFuture of: #Collection of: #BlElement>
	^ elementCache
		at: aCompiledMethod
		ifPresent: [ :someElements | someElements asAsyncFuture ]
		ifAbsent: [ | aCoderViewModel someElements |
			aCoderViewModel := self
					addOnsFutureForCompiledMethod: aCompiledMethod.

			aCoderViewModel addOnsFuture
				map: [ :addOns | 
					someElements := addOns previews
							collect: [ :eachAddOn | 
								| eachAddOnElement |
								eachAddOnElement := eachAddOn stencil asElement.
								eachAddOn dataBinder
									element: eachAddOnElement;
									coderViewModel: aCoderViewModel;
									build.
								eachAddOnElement ].

					elementCache at: aCompiledMethod put: someElements.

					someElements ] ]
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodsAddOnsCache >> initialize [
	super initialize.

	elementCache := AsyncSharedWeakIdentityKeyDictionary new.
	coderViewModelCache := AsyncSharedWeakIdentityKeyDictionary new.
]

{ #category : #'event handling' }
GtCoderNavigationCompiledMethodsAddOnsCache >> onClassAddedOrRemoved: anAnnouncement [
	elementCache
		keysAndValuesRemove: [ :eachCompiledMethod :someElements | 
			(eachCompiledMethod methodClass inheritsFrom: anAnnouncement classAffected)
				or: [ anAnnouncement classAffected inheritsFrom: eachCompiledMethod methodClass ] ]
]

{ #category : #'event handling' }
GtCoderNavigationCompiledMethodsAddOnsCache >> onMethodAddedOrRemoved: anAnnouncement [
	elementCache
		keysAndValuesRemove: [ :eachCompiledMethod :someElements | 
			(eachCompiledMethod methodClass inheritsFrom: anAnnouncement classAffected)
				or: [ anAnnouncement classAffected inheritsFrom: eachCompiledMethod methodClass ] ]
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodsAddOnsCache >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when: MethodAdded , MethodRemoved, MethodModified
			send: #onMethodAddedOrRemoved:
			to: self;
		when: ClassAdded , ClassRemoved
			send: #onClassAddedOrRemoved:
			to: self
]

{ #category : #initialization }
GtCoderNavigationCompiledMethodsAddOnsCache >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]
