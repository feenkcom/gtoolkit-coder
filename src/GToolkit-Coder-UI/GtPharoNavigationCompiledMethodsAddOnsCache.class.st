Class {
	#name : #GtPharoNavigationCompiledMethodsAddOnsCache,
	#superclass : #Object,
	#instVars : [
		'elementCache',
		'coderViewModelCache'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #private }
GtPharoNavigationCompiledMethodsAddOnsCache >> addOnsFutureForCompiledMethod: aCompiledMethod hostElement: aHostElement [
	<return: #GtTextualCoderViewModel>
	| coderViewModel |
	coderViewModel := coderViewModelCache
			at: aCompiledMethod
			ifPresent: [ :aCoderViewModel | aCoderViewModel ]
			ifAbsentPut: [ (GtPharoMethodCoder forMethod: aCompiledMethod)
					asCoderViewModel ].

	^ coderViewModel
]

{ #category : #private }
GtPharoNavigationCompiledMethodsAddOnsCache >> computeElementsForCompiledMethod: aCompiledMethod hostElement: aHostElement [
	<return: #Collection of: #BlElement>
	| someElements |
	someElements := GtCoderNavigationMethodTarget
			actionsForObject: aCompiledMethod
			collect: [ :eachAction | eachAction asNavigationElement: [ :e | e ] withHostElement: aHostElement ].
	elementCache at: aCompiledMethod put: someElements.
	^ someElements
]

{ #category : #accessing }
GtPharoNavigationCompiledMethodsAddOnsCache >> elementsForCompiledMethod: aCompiledMethod hostElement: aHostElement [
	<return: #TAsyncFuture of: #Collection of: #BlElement>
	^ elementCache
		at: aCompiledMethod
		ifPresent: [ :someElements | someElements asAsyncFuture ]
		ifAbsent: [ | aCoderViewModel someElements |
			aCoderViewModel := self
					addOnsFutureForCompiledMethod: aCompiledMethod
					hostElement: aHostElement.

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
GtPharoNavigationCompiledMethodsAddOnsCache >> initialize [
	super initialize.

	elementCache := AsyncSharedWeakIdentityKeyDictionary new.
	coderViewModelCache := AsyncSharedWeakIdentityKeyDictionary new.
]

{ #category : #'event handling' }
GtPharoNavigationCompiledMethodsAddOnsCache >> onClassAddedOrRemoved: anAnnouncement [
	elementCache
		keysAndValuesRemove: [ :eachCompiledMethod :someElements | 
			(eachCompiledMethod methodClass inheritsFrom: anAnnouncement classAffected)
				or: [ anAnnouncement classAffected inheritsFrom: eachCompiledMethod methodClass ] ]
]

{ #category : #'event handling' }
GtPharoNavigationCompiledMethodsAddOnsCache >> onMethodAddedOrRemoved: anAnnouncement [
	elementCache
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
