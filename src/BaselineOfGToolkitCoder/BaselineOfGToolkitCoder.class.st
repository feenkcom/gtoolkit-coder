"
1. Coder
Coder is a set of components for creating and manipulating code.
1. # Method coder

The smallest unit is the {{gtClass:GtMethodCoder}} which, as the name says, focuses on editing one single method.

{{gtExample:GtMethodCoderExamples>>#keywordSelectorCoder|noCode=|previewShow=#gtLiveFor:|previewHeight=150}}

The method coder can mold dynamically to fit the context of the current method. For example, when the method is annotated with `<gtExample>`, the coder is embellished with the possibility to run the method as an example, and see the result as a label. This happens dynamically. Give it a try below.

{{gtExample:GtMethodCoderExamples>>#thisMethod|noCode=|previewShow=#gtLiveFor:|previewHeight=300}}
1. # Filters

Method coders can be combined in different ways for different purposes. One of these purposes is searching. This is achieved by means of {{gtClass:GtSearchMethodsFilter}}.

For example, below you see the result of a code query. Expanding the resulting method coders highlights the specific nodes that matched the query.

{{gtExample:GtSearchMethodFilterExamples>>#gtExamplePragmas|previewExpanded=|previewShow=#gtItemsFor:|codeExpanded=false}}

See {{gtClass:GtSearchMethodFilterExamples}} for more details.


"
Class {
	#name : #BaselineOfGToolkitCoder,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitCoder
}

{ #category : #baseline }
BaselineOfGToolkitCoder >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'Futures' with: [
				spec repository: 'github://feenkcom/pharo-futures:v0.6.26/src' ].
		spec
			baseline: 'GToolkitBasicUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.88/src' ].
		spec
			baseline: 'GToolkitAnnouncerUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.88/src' ].
		spec
			baseline: 'GToolkitPager' with: [
				spec repository: 'github://feenkcom/gtoolkit-pager:v0.8.492/src' ].
		spec
			baseline: 'GToolkitCompleter' with: [
				spec repository: 'github://feenkcom/gtoolkit-completer:v0.8.489/src' ].

		spec package: 'GToolkit-VariableBindings'.
		spec package: 'GToolkit-SearchFilters' with: [
			spec requires: #('Futures') ].
		spec package: 'GToolkit-Coder-StreamingCoders' with: [
			spec requires: #('Futures' 'GToolkit-SearchFilters') ].
		spec package: 'GToolkit-Coder-StreamingCoders-UI' with: [
			spec requires: #('Futures' 'GToolkit-Coder-StreamingCoders') ].
		spec package: 'GToolkit-Coder' with: [
			spec requires: #('Futures' 'GToolkitBasicUtility' 'GToolkitAnnouncerUtility' 'GToolkitPager' 'GToolkitCompleter' 'GToolkit-SearchFilters') ].
		spec package: 'GToolkit-Coder-UI' with: [
			spec requires: #('GToolkit-Coder' 'GToolkit-VariableBindings' 'GToolkitBasicUtility' 'GToolkitPager') ].
		spec package: 'GToolkit-Coder-AddOns' with: [
			spec requires: #('GToolkit-Coder' 'GToolkit-Coder-UI') ].
		spec package: 'GToolkit-Coder-Extensions' with: [
			spec requires: #('GToolkit-Coder' 'GToolkit-Coder-UI' 'GToolkit-Coder-AddOns') ].
		spec package: 'GToolkit-Coder-Examples-SystemS1'.
		spec package: 'GToolkit-Coder-Examples' with: [
			spec requires: #('GToolkit-Coder' 'GToolkit-Coder-UI' 'GToolkit-Coder-AddOns' 'GToolkit-Coder-Examples-SystemS1') ].
	]
]
