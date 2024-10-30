<?php
/*
        Plugin Name: MetaTagGenerator
        Plugin URI: http://blogs.hiveworks.com/msa/content/binary/wordpress/mtg.tar.gz
        Description: A plugin that generates meta tags out of the nouns of the posts
        Author: Michalis Sarigiannidis
        Version: 1.0
        Author URI: http://blogs.hiveworks.com/msa/
*/

function filterNouns($text)
{
        $text = preg_replace("/(\W)/", " ", $text);

       $nouns = shell_exec('/usr/bin/perl /htdocs/hiveworks.com/blogs/htdocs/msa/wp-content/plugins/metaTagGenerator.pl "'.$text.'"');
        if (!(isset($nouns) && is_string($nouns)))
		$nouns ='';

        return $nouns;
}

function generateMetaTags($postID)
{
        $postData = get_postdata($postID);
        $text = $postData['Title'].' '.$postData['Excerpt'].' '.$postData['Content'];
        $nouns = filterNouns($text);

	$nouns = 'name="keywords" content="'.$nouns.'"';

        if (!update_post_meta($postID, 'head_meta', $nouns))
                add_post_meta($postID, 'head_meta', $nouns, true);
}

add_action('save_post', 'generateMetaTags');
add_action('edit_post', 'generateMetaTags');
add_action('publish_post', 'generateMetaTags');
?>
