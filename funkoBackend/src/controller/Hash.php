<?php

    namespace App\controller;

    class Hash {
        public static function hash(string $text) :string {
            return password_hash($text, PASSWORD_BCRYPT, ['cost' => 10]);
        }
    }